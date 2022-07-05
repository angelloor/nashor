import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { LevelProfileService } from '../level-profile.service';
import { LevelProfile } from '../level-profile.types';
import { ModalSelectLevelProfileService } from './modal-select-level-profile.service';

@Component({
  selector: 'app-modal-select-level-profile',
  templateUrl: './modal-select-level-profile.component.html',
})
export class ModalSelectLevelProfileComponent implements OnInit {
  id_level_profile: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listLevelProfile: LevelProfile[] = [];
  selectLevelProfileForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _levelProfileService: LevelProfileService,
    private _modalSelectLevelProfileService: ModalSelectLevelProfileService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of levelProfile
     */
    this._levelProfileService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_levelProfiles: LevelProfile[]) => {
        this.listLevelProfile = _levelProfiles;
      });
    /**
     * form
     */
    this.selectLevelProfileForm = this._formBuilder.group({
      id_level_profile: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectLevelProfileForm.patchValue({
      id_level_profile:
        this.selectLevelProfileForm.getRawValue().id_level_profile,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_level_profile =
      this.selectLevelProfileForm.getRawValue().id_level_profile;
    this.patchForm();
  }
  /**
   * closeModalSelectLevelProfile
   */
  closeModalSelectLevelProfile(): void {
    this._modalSelectLevelProfileService.closeModalSelectLevelProfile();
  }
}
