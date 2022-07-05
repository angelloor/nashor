import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { LevelService } from '../level.service';
import { Level } from '../level.types';
import { ModalSelectLevelService } from './modal-select-level.service';

@Component({
  selector: 'app-modal-select-level',
  templateUrl: './modal-select-level.component.html',
})
export class ModalSelectLevelComponent implements OnInit {
  id_level: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listLevel: Level[] = [];
  selectLevelForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _levelService: LevelService,
    private _modalSelectLevelService: ModalSelectLevelService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of level
     */
    this._levelService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_levels: Level[]) => {
        this.listLevel = _levels;
      });
    /**
     * form
     */
    this.selectLevelForm = this._formBuilder.group({
      id_level: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectLevelForm.patchValue({
      id_level: this.selectLevelForm.getRawValue().id_level,
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
    this.id_level = this.selectLevelForm.getRawValue().id_level;
    this.patchForm();
  }
  /**
   * closeModalSelectLevel
   */
  closeModalSelectLevel(): void {
    this._modalSelectLevelService.closeModalSelectLevel();
  }
}
