import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { LevelStatusService } from '../level-status.service';
import { LevelStatus } from '../level-status.types';
import { ModalSelectLevelStatusService } from './modal-select-level-status.service';

@Component({
  selector: 'app-modal-select-level-status',
  templateUrl: './modal-select-level-status.component.html',
})
export class ModalSelectLevelStatusComponent implements OnInit {
  id_level_status: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listLevelStatus: LevelStatus[] = [];
  selectLevelStatusForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _levelStatusService: LevelStatusService,
    private _modalSelectLevelStatusService: ModalSelectLevelStatusService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of levelStatus
     */
    this._levelStatusService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_levelStatuss: LevelStatus[]) => {
        this.listLevelStatus = _levelStatuss;
      });
    /**
     * form
     */
    this.selectLevelStatusForm = this._formBuilder.group({
      id_level_status: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectLevelStatusForm.patchValue({
      id_level_status: this.selectLevelStatusForm.getRawValue().id_level_status,
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
    this.id_level_status =
      this.selectLevelStatusForm.getRawValue().id_level_status;
    this.patchForm();
  }
  /**
   * closeModalSelectLevelStatus
   */
  closeModalSelectLevelStatus(): void {
    this._modalSelectLevelStatusService.closeModalSelectLevelStatus();
  }
}
