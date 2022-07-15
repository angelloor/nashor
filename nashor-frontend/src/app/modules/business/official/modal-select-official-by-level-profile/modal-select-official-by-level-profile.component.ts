import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { LevelProfileOfficialService } from '../../level-profile/level-profile-official/level-profile-official.service';
import { LevelProfileOfficial } from '../../level-profile/level-profile-official/level-profile-official.types';
import { ModalSelectOfficialByLevelProfileService } from './modal-select-official-by-level-profile.service';

@Component({
  selector: 'app-modal-select-official-by-level-profile',
  templateUrl: './modal-select-official-by-level-profile.component.html',
})
export class ModalSelectOfficialByLevelProfileComponent implements OnInit {
  id_level_profile: string = '';
  id_user_: string = '';
  id_official: string = '';
  id_level_profile_official: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listLevelProfileOfficial: LevelProfileOfficial[] = [];
  selectOfficialForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _levelProfileOfficialService: LevelProfileOfficialService,
    private _modalSelectOfficialByLevelProfileService: ModalSelectOfficialByLevelProfileService
  ) {}

  ngOnInit(): void {
    this.id_level_profile = this._data.id_level_profile;
    this.id_user_ = this._data.id_user_;
    /**
     * get the list of official
     */
    this._levelProfileOfficialService
      .byLevelProfileRead(this.id_level_profile)
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_levelProfileOfficial: LevelProfileOfficial[]) => {
        /**
         * Filter selected official
         */
        _levelProfileOfficial.map(
          (item: LevelProfileOfficial, index: number) => {
            if (item.official.user.id_user == this.id_user_) {
              _levelProfileOfficial[index] = {
                ..._levelProfileOfficial[index],
                isSelected: true,
              };
            } else {
              _levelProfileOfficial[index] = {
                ..._levelProfileOfficial[index],
                isSelected: false,
              };
            }
          }
        );
        console.log(_levelProfileOfficial);

        this.listLevelProfileOfficial = _levelProfileOfficial;
      });
    /**
     * form
     */
    this.selectOfficialForm = this._formBuilder.group({
      id_level_profile_official: ['', [Validators.required]],
      number_task: [''],
    });
  }
  /**
   * patchForm
   * @param number_task
   */
  patchForm(number_task: number): void {
    this.selectOfficialForm.patchValue({
      id_level_profile_official:
        this.selectOfficialForm.getRawValue().id_level_profile_official,
      number_task: number_task,
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
    this.id_level_profile_official =
      this.selectOfficialForm.getRawValue().id_level_profile_official;

    let selectedlevelProfileOfficial = this.listLevelProfileOfficial.find(
      (item) => item.id_level_profile_official == this.id_level_profile_official
    )!;

    this.id_official = selectedlevelProfileOfficial.official.id_official;
    this.patchForm(selectedlevelProfileOfficial.number_task!);
  }
  /**
   * closeModalSelectOfficialByLevelProfile
   */
  closeModalSelectOfficialByLevelProfile(): void {
    this._modalSelectOfficialByLevelProfileService.closeModalSelectOfficialByLevelProfile();
  }
}
